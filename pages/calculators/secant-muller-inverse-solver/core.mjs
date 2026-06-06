export function computeNextX(points, options = {}) {
  const targetY = finiteOrDefault(options.targetY, 1.0);
  const stepSize = finiteOrDefault(options.stepSize, 1.0);
  const method = String(options.method || "").toLowerCase();
  const denomTol = finiteOrDefault(options.denominatorTol, 1e-12);
  const dupTol = finiteOrDefault(options.duplicateXTol, 1e-12);

  const out = {
    ok: false,
    methodUsed: "",
    xNext: Number.NaN,
    deltaBase: Number.NaN,
    blockedReason: ""
  };

  if (!Array.isArray(points) || points.length < 2) {
    out.blockedReason = "insufficient_points";
    return out;
  }

  const valid = points.filter((row) => (
    Array.isArray(row)
    && row.length >= 2
    && Number.isFinite(row[0])
    && Number.isFinite(row[1])
  ));

  if (valid.length < 2) {
    out.blockedReason = "insufficient_points";
    return out;
  }

  const methodUsed = normalizeMethod(method, valid.length);
  if (!methodUsed) {
    out.blockedReason = "insufficient_points";
    return out;
  }
  out.methodUsed = methodUsed;

  let deltaResult;
  let windowPoints;
  if (methodUsed === "secant") {
    windowPoints = valid.slice(-2);
    deltaResult = secantDelta(windowPoints, targetY, denomTol, dupTol);
  } else {
    if (valid.length < 3) {
      out.blockedReason = "insufficient_points";
      return out;
    }
    windowPoints = valid.slice(-3);
    deltaResult = mullerDelta(windowPoints, targetY, denomTol, dupTol);
  }

  if (!deltaResult.ok) {
    out.blockedReason = deltaResult.blockedReason;
    return out;
  }

  const xCurrent = windowPoints[windowPoints.length - 1][0];
  out.deltaBase = deltaResult.deltaBase;
  out.xNext = xCurrent + stepSize * deltaResult.deltaBase;
  out.ok = Number.isFinite(out.xNext);

  if (!out.ok) {
    out.blockedReason = "invalid_number";
  }

  return out;
}

export function secantDelta(points, targetY, denomTol, dupTol) {
  const [x1, y1] = points[0];
  const [x2, y2] = points[1];

  if (Math.abs(x2 - x1) <= dupTol) {
    return blocked("repeated_x");
  }

  const g1 = y1 - targetY;
  const g2 = y2 - targetY;
  const denom = g2 - g1;

  if (Math.abs(denom) <= denomTol) {
    return blocked("zero_denominator");
  }

  return ok((-g2 * (x2 - x1)) / denom);
}

export function mullerDelta(points, targetY, denomTol, dupTol) {
  const [x0, y0] = points[0];
  const [x1, y1] = points[1];
  const [x2, y2] = points[2];

  if (
    Math.abs(x1 - x0) <= dupTol
    || Math.abs(x2 - x1) <= dupTol
    || Math.abs(x2 - x0) <= dupTol
  ) {
    return blocked("repeated_x");
  }

  const g0 = y0 - targetY;
  const g1 = y1 - targetY;
  const g2 = y2 - targetY;

  const h0 = x1 - x0;
  const h1 = x2 - x1;
  if (Math.abs(h0) <= denomTol || Math.abs(h1) <= denomTol || Math.abs(h0 + h1) <= denomTol) {
    return blocked("zero_denominator");
  }

  const d0 = (g1 - g0) / h0;
  const d1 = (g2 - g1) / h1;
  const a = (d1 - d0) / (h1 + h0);
  const b = d1 + h1 * a;
  const c = g2;

  const disc = b * b - 4 * a * c;
  if (disc < 0) {
    return blocked("complex_muller_step");
  }

  const sqrtDisc = Math.sqrt(disc);
  if (!Number.isFinite(sqrtDisc)) {
    return blocked("invalid_number");
  }

  const ePlus = b + sqrtDisc;
  const eMinus = b - sqrtDisc;
  const e = Math.abs(ePlus) >= Math.abs(eMinus) ? ePlus : eMinus;

  if (Math.abs(e) <= denomTol) {
    return blocked("zero_denominator");
  }

  const delta = (-2 * c) / e;
  if (!Number.isFinite(delta)) {
    return blocked("invalid_number");
  }

  return ok(delta);
}

export function normalizeMethod(method, nPoints) {
  if (!method) {
    return nPoints >= 3 ? "muller" : "secant";
  }
  if (method === "secant" && nPoints >= 2) {
    return "secant";
  }
  if (method === "muller" && nPoints >= 3) {
    return "muller";
  }
  return "";
}

function finiteOrDefault(value, fallback) {
  return Number.isFinite(value) ? Number(value) : fallback;
}

function blocked(reason) {
  return { ok: false, blockedReason: reason, deltaBase: Number.NaN };
}

function ok(deltaBase) {
  return { ok: true, blockedReason: "", deltaBase };
}

const api = {
  computeNextX,
  secantDelta,
  mullerDelta,
  normalizeMethod
};

export default api;