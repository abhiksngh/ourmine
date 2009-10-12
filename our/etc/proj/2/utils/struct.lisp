(defstruct normbins
  name    ;symbol         :name of the chopped table
  data    ;list of bins   :all bins
)

(defstruct bin
  num     ;number         :bin number
  ele     ;list of eg     :all records in bin
)
