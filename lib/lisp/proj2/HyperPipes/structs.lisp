(defstruct ExperienceInstance attributes class)

(defstruct HyperPipe numericBounds class)

(defstruct NumericBound (min most-positive-fixnum) (max most-negative-fixnum) (nonNumeric (list)))
