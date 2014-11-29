class ListEntry < ActiveRecord::Base
  belongs_to :list
  belongs_to :listable, polymorphic: true
end

# == Schema Information
#
# Table name: list_entries
#
#  id            :integer          not null, primary key
#  list_id       :integer
#  listable_id   :integer
#  listable_type :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#
# Indexes
#
#  index_list_entries_on_list_id_and_listable_id_and_listable_type  (list_id,listable_id,listable_type) UNIQUE
#
