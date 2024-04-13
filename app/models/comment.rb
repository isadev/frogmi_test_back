class Comment < ApplicationRecord
    belongs_to :earthquake, foreign_key: "feature_id"
end
