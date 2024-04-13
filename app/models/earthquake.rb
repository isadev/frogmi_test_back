class Earthquake < ApplicationRecord
    has_many :comments, foreign_key: "feature_id", dependent: :destroy
end
