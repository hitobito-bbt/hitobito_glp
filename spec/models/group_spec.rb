# encoding: utf-8

#  Copyright (c) 2012-2019, GLP Schweiz. This file is part of
#  hitobito_glp and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_glp.


require 'spec_helper'

describe Group do

  include_examples 'group types'

  it 'asserts that zip_codes are uniq' do
    groups(:zurich).update!(zip_codes: '8000')

    vd = Group::Kanton.new(name: 'jGLP vd', parent: groups(:root), zip_codes: '3012,9171,8000')
    expect(vd).not_to be_valid
    expect(vd.errors[:zip_codes]).to have(2).items
    expect(vd.errors[:zip_codes]).to match_array([
      '"3012,9171" sind bereits auf der Gruppe "Bern" vergeben',
      '"8000" ist bereits auf der Gruppe "Zurich" vergeben'
    ])
  end

  it 'still accepts groups without zip_codes' do
    vd = Group::Kanton.new(name: 'jGLP vd', parent: groups(:root))
    expect(vd).to be_valid
  end

  it 'still accepts groups with same zip_code in different subtree' do
    jglp = Group::Kanton.create!(name: 'jGLP', parent: groups(:root))
    vd = Group::Bezirk.new(name: 'jGLP vd', parent: jglp, zip_codes: '3012,9171,8000')
    expect(vd).to be_valid
  end
end
