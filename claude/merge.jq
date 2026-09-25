# Merge the baseline (first input) into a config dir's settings (second input).
# Objects merge key by key, arrays are combined, and the baseline wins any
# other conflict, so its security switches always apply.
def m($base; $mine):
  if ($base|type) == "object" and ($mine|type) == "object" then
    reduce (($base + $mine) | keys[]) as $k ({}; .[$k] = m($base[$k]; $mine[$k]))
  elif ($base|type) == "array" and ($mine|type) == "array" then $mine + $base | unique
  elif $base == null then $mine else $base end;
m(.[0]; .[1])
