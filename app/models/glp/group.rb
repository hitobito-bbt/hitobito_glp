# encoding: utf-8

#  Copyright (c) 2012-2018, Grünliberale Partei Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

module Glp::Group
  extend ActiveSupport::Concern

  included do
    # self.used_attributes += [:zip_codes]
    # serialize :zip_codes, Array

    root_types Group::Root
    validate :assert_zip_codes_uniq

    scope :with_zip_codes, -> { where.not(zip_codes: ['', nil]) }
  end

  def assert_zip_codes_uniq
    groups = Group.with_zip_codes.where.not(id: self.id).pluck(:id, :zip_codes)
    group_codes = zip_codes.to_s.squish.split(',')
    groups.each do |group_id, zip_code_string|
      other_codes = zip_code_string.squish.split(',')
      shared = group_codes & other_codes

      unless shared.empty?
        group = Group.find(group_id)
        errors.add(:zip_codes, :not_uniq, group: group, shared: shared.join(','), count: shared.size)
      end
    end
  end
end
