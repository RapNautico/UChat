class Comment < ApplicationRecord
    belongs_to :publish
    belongs_to :user


    paginates_per 2

    has_rich_text :body
end
