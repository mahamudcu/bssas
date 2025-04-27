json.extract! committee_member, :id, :user_id, :committee_id, :committee_designation_id, :added_by_id, :remove_by_id, :approve_by_id, :is_approved, :description, :created_at, :updated_at
json.url committee_member_url(committee_member, format: :json)
