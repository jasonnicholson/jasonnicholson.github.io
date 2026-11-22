# write exact Taylor coefficients (from check_coeffs.py) to exact_coeffs.txt
import os, io, contextlib, importlib.util
here = os.path.dirname(os.path.abspath(__file__))
spec = importlib.util.spec_from_file_location("cc", os.path.join(here, "check_coeffs.py"))
with contextlib.redirect_stdout(io.StringIO()):
    cc = importlib.util.module_from_spec(spec); spec.loader.exec_module(cc)
with open(os.path.join(here, "exact_coeffs.txt"), "w") as fh:
    for cid, row in cc.rows.items():
        fh.write(cid + " " + " ".join(repr(v) for v in row[5]) + "\n")
