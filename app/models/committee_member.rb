class CommitteeMember < ApplicationRecord
  belongs_to :user
  belongs_to :committee
  belongs_to :committee_designation
end
