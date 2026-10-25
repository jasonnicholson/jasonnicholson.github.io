import core from "./core.mjs";

const DEFAULT_ROW_COUNT = 20;
const STATIC_CELLS = new Set(["1:method", "1:step", "2:method"]);

export async function initSecantMullerInverseApp(root, options = {}) {
  const cfg = await loadContract();
  const rowCount = Number.isInteger(options.rowCount) && options.rowCount > 1
    ? options.rowCount
    : DEFAULT_ROW_COUNT;

  root.innerHTML = renderMarkup(rowCount, cfg.targetYDefault ?? 1.0);

  const targetInput = root.querySelector('[data-role="target-y"]');
  const status = root.querySelector('[data-role="status"]');
  const tbody = root.querySelector('[data-role="body"]');
  const loadExampleButton = root.querySelector('[data-role="load-example"]');
  const clearButton = root.querySelector('[data-role="clear-table"]');

  for (let i = 1; i <= rowCount; i += 1) {
    tbody.appendChild(buildRow(i));
  }
  applyStaticCellLocks(tbody);
  refreshMethodHints(tbody);

  loadExampleButton?.addEventListener("click", () => {
    fillExampleRows(tbody, targetInput);
    refreshMethodHints(tbody);
    status.textContent = "Example rows loaded (1-7). Edit y, step size, or method in a row to trigger next-row x.";
  });

  clearButton?.addEventListener("click", () => {
    clearRows(tbody);
    applyStaticCellLocks(tbody);
    refreshMethodHints(tbody);
    status.textContent = "Cleared. Enter x/y points. Secant needs 2 valid points; Muller needs 3.";
  });

  root.addEventListener("change", (event) => {
    const input = event.target;
    if (!(input instanceof HTMLInputElement || input instanceof HTMLSelectElement)) {
      return;
    }

    const rowEl = input.closest("tr");
    if (!rowEl) {
      return;
    }

    const rowIndex = Number(rowEl.dataset.row);
    const triggerField = String(input.dataset.field || "").toLowerCase();

    if (isStaticCell(rowIndex, triggerField)) {
      restoreStaticCell(tbody, rowIndex, triggerField);
      status.textContent = `Row ${rowIndex} ${triggerField} is fixed by design.`;
      refreshMethodHints(tbody);
      return;
    }

    if (!["y", "step", "method"].includes(triggerField)) {
      status.textContent = "Edit accepted (no recompute trigger).";
      refreshMethodHints(tbody);
      return;
    }

    const points = collectPointsUpToRow(tbody, rowIndex);
    const method = getCellValue(tbody, rowIndex, "method") || "";
    const stepSize = Number(getCellValue(tbody, rowIndex, "step"));
    const targetY = Number(targetInput.value);

    const out = core.computeNextX(points, {
      targetY,
      stepSize: Number.isFinite(stepSize) ? stepSize : 1.0,
      method,
      denominatorTol: cfg?.tolerance?.denominator ?? 1e-12,
      duplicateXTol: cfg?.tolerance?.duplicateX ?? 1e-12
    });

    const targetRow = rowIndex + 1;
    if (targetRow > rowCount) {
      status.textContent = `Row ${targetRow} is out of range; nothing to update.`;
      refreshMethodHints(tbody);
      return;
    }

    if (out.ok) {
      setCellValue(tbody, targetRow, "x", out.xNext);
      status.textContent = `Computed row ${targetRow} x = ${formatNumber(out.xNext)} (${out.methodUsed})`;
    } else {
      const message = blockedMessage(out.blockedReason, {
        method,
        validPointCount: points.length
      });
      status.textContent = `Row ${targetRow} compute blocked: ${message}`;
    }

    refreshMethodHints(tbody);
  });
}

function renderMarkup(rowCount, targetYDefault) {
  return `
    <div class="smi-root">
      <div class="smi-controls">
        <label>Target y
          <input data-role="target-y" type="number" step="any" value="${targetYDefault}">
        </label>
        <button type="button" data-role="load-example">Load Example Rows</button>
        <button type="button" data-role="clear-table">Clear</button>
        <span class="smi-status" data-role="status">Ready. Edit Method, Step Size, or y in row n to compute x in row n+1.</span>
      </div>
      <div class="smi-table-wrap">
        <table class="smi-table">
          <thead>
            <tr>
              <th>Iteration</th>
              <th>Method</th>
              <th>Step Size</th>
              <th>x</th>
              <th>y</th>
            </tr>
          </thead>
          <tbody data-role="body"></tbody>
        </table>
      </div>
    </div>
  `;
}

function buildRow(iteration) {
  const tr = document.createElement("tr");
  tr.dataset.row = String(iteration);
  const defaultMethod = iteration >= 3 ? "muller" : "secant";

  tr.innerHTML = `
    <td>${iteration}</td>
    <td>
      <select data-field="method">
        <option value="secant" ${defaultMethod === "secant" ? "selected" : ""}>secant</option>
        <option value="muller" ${defaultMethod === "muller" ? "selected" : ""}>muller</option>
      </select>
    </td>
    <td><input data-field="step" type="number" step="any" value="1"></td>
    <td><input data-field="x" type="number" step="any"></td>
    <td><input data-field="y" type="number" step="any"></td>
  `;
  return tr;
}

function collectPointsUpToRow(tbody, rowIndex) {
  const points = [];
  for (let r = 1; r <= rowIndex; r += 1) {
    const x = Number(getCellValue(tbody, r, "x"));
    const y = Number(getCellValue(tbody, r, "y"));
    if (Number.isFinite(x) && Number.isFinite(y)) {
      points.push([x, y]);
    }
  }
  return points;
}

function getCellValue(tbody, rowIndex, field) {
  const row = tbody.querySelector(`tr[data-row="${rowIndex}"]`);
  const el = row?.querySelector(`[data-field="${field}"]`);
  return el?.value ?? "";
}

function setCellValue(tbody, rowIndex, field, value) {
  const row = tbody.querySelector(`tr[data-row="${rowIndex}"]`);
  const el = row?.querySelector(`[data-field="${field}"]`);
  if (el) {
    el.value = String(value);
  }
}

function formatNumber(value) {
  if (!Number.isFinite(value)) {
    return "NaN";
  }
  return Number(value).toPrecision(10);
}

function blockedMessage(reason, context) {
  const method = String(context?.method || "").toLowerCase();
  const n = Number(context?.validPointCount || 0);

  if (reason === "insufficient_points") {
    if (method === "muller") {
      return `need 3 valid points for muller; currently ${n}`;
    }
    if (method === "secant") {
      return `need 2 valid points for secant; currently ${n}`;
    }
    return `need more valid points (secant: 2, muller: 3); currently ${n}`;
  }
  if (reason === "repeated_x") {
    return "x values are repeated or too close; use distinct x points";
  }
  if (reason === "zero_denominator") {
    return "slope/denominator is near zero; try new points or different method";
  }
  if (reason === "complex_muller_step") {
    return "muller step became complex; use secant or adjust points";
  }
  if (reason === "invalid_number") {
    return "numeric overflow/invalid value; reduce step or adjust points";
  }
  return reason || "unknown block";
}

function refreshMethodHints(tbody) {
  const rows = tbody.querySelectorAll("tr[data-row]");
  for (const row of rows) {
    const rowIndex = Number(row.dataset.row || 0);
    const methodSelect = row.querySelector('select[data-field="method"]');
    if (!(methodSelect instanceof HTMLSelectElement)) {
      continue;
    }

    const n = collectPointsUpToRow(tbody, rowIndex).length;
    const secantReady = n >= 2;
    const mullerReady = n >= 3;
    const secantOption = methodSelect.querySelector('option[value="secant"]');
    const mullerOption = methodSelect.querySelector('option[value="muller"]');

    if (secantOption) {
      secantOption.disabled = !secantReady;
    }
    if (mullerOption) {
      mullerOption.disabled = !mullerReady;
    }

    let selected = String(methodSelect.value || "").toLowerCase();
    const selectedReady = (selected === "secant" && secantReady) || (selected === "muller" && mullerReady);
    if (!selectedReady) {
      if (mullerReady) {
        methodSelect.value = "muller";
      } else if (secantReady) {
        methodSelect.value = "secant";
      }
      selected = String(methodSelect.value || "").toLowerCase();
    }

    methodSelect.title = `Available with current points -> secant: ${secantReady ? "yes" : "no"} (needs 2), muller: ${mullerReady ? "yes" : "no"} (needs 3)`;
    const finalReady = (selected === "secant" && secantReady) || (selected === "muller" && mullerReady);
    const lockedStaticMethodCell = isStaticCell(rowIndex, "method");
    methodSelect.classList.toggle("smi-method-not-ready", !finalReady && !lockedStaticMethodCell);
  }
}

function fillExampleRows(tbody, targetInput) {
  targetInput.value = "0";
  clearRows(tbody);
  const example = [
    { row: 1, method: "secant", step: "1", x: "1.6", y: "1.0122" },
    { row: 2, method: "secant", step: "1", x: "1.5", y: "0.9828" },
    { row: 3, method: "muller", step: "1", x: "-1.8417", y: "-1.0734" },
    { row: 4, method: "muller", step: "1", x: "-0.5038", y: "-0.4667" },
    { row: 5, method: "muller", step: "1", x: "0.2463", y: "0.2415" },
    { row: 6, method: "muller", step: "1", x: "0.02", y: "0.02" },
    { row: 7, method: "muller", step: "1", x: "-7.703e-04", y: "" }
  ];

  for (const item of example) {
    setCellValue(tbody, item.row, "method", item.method);
    setCellValue(tbody, item.row, "step", item.step);
    setCellValue(tbody, item.row, "x", item.x);
    setCellValue(tbody, item.row, "y", item.y);
  }
}

function clearRows(tbody) {
  const rows = tbody.querySelectorAll("tr[data-row]");
  for (const row of rows) {
    const rowIndex = Number(row.dataset.row || 0);
    const defaultMethod = rowIndex >= 3 ? "muller" : "secant";
    setCellValue(tbody, rowIndex, "method", defaultMethod);
    setCellValue(tbody, rowIndex, "step", "1");
    setCellValue(tbody, rowIndex, "x", "");
    setCellValue(tbody, rowIndex, "y", "");
  }
}

function applyStaticCellLocks(tbody) {
  for (const key of STATIC_CELLS) {
    const [row, field] = key.split(":");
    const rowIndex = Number(row);
    restoreStaticCell(tbody, rowIndex, field);
    const el = getCellInput(tbody, rowIndex, field);
    if (el instanceof HTMLInputElement) {
      el.readOnly = true;
      el.disabled = true;
      el.classList.add("smi-cell-locked");
      el.title = "Locked static cell";
    } else if (el instanceof HTMLSelectElement) {
      el.disabled = true;
      el.classList.add("smi-cell-locked");
      el.title = "Locked static cell";
    }
  }
}

function isStaticCell(rowIndex, field) {
  return STATIC_CELLS.has(`${rowIndex}:${field}`);
}

function restoreStaticCell(tbody, rowIndex, field) {
  if (rowIndex === 1 && field === "method") {
    setCellValue(tbody, rowIndex, field, "secant");
    return;
  }
  if (rowIndex === 1 && field === "step") {
    setCellValue(tbody, rowIndex, field, "1");
    return;
  }
  if (rowIndex === 2 && field === "method") {
    setCellValue(tbody, rowIndex, field, "secant");
  }
}

function getCellInput(tbody, rowIndex, field) {
  const row = tbody.querySelector(`tr[data-row="${rowIndex}"]`);
  return row?.querySelector(`[data-field="${field}"]`) ?? null;
}

async function loadContract() {
  try {
    const contractUrl = new URL("./contract.json", import.meta.url);
    const response = await fetch(contractUrl, { cache: "no-store" });
    if (!response.ok) {
      return {};
    }
    return await response.json();
  } catch {
    return {};
  }
}
