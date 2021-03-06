require 'test_helper'

class DocumentSeriesGroupTest < ActiveSupport::TestCase
  test 'new groups should set #ordering when assigned to a series' do
    series = create(:document_collection, groups: [
      build(:document_collection_group),
      build(:document_collection_group)
    ])
    assert_equal [1, 2], series.groups.reload.map(&:ordering)
  end

  test 'should list published editions in reverse chronological order' do
    group = create(:document_collection_group)
    published_1 = create(:published_publication, first_published_at: 2.days.ago)
    published_2 = create(:published_publication, first_published_at: 1.day.ago)
    draft = create(:draft_publication)
    group.documents << [published_1.document, published_2.document, draft.document]
    assert_equal [published_2, published_1], group.published_editions
  end

  test 'should list latest editions in reverse chronological order, with drafts at the end' do
    group = create(:document_collection_group)
    draft = create(:draft_publication)
    new = create(:published_publication, first_published_at: 1.day.ago)
    old = create(:published_publication, first_published_at: 2.days.ago)
    group.documents = [draft.document, new.document, old.document]
    assert_equal [new, old, draft], group.latest_editions
  end

  test 'dup should also clone document memberships' do
    group = create(:document_collection_group, documents: [
      doc_1 = build(:document),
      doc_2 = build(:document),
      doc_3 = build(:document)
    ])

    group.memberships[0].ordering = 2
    group.memberships[1].ordering = 1
    group.memberships[2].ordering = 3

    new_group = group.dup

    assert_not_equal group.memberships[0],          new_group.memberships[0]
    assert_equal     group.memberships[0].document, new_group.memberships[0].document
    assert_equal     1,                             new_group.memberships[1].ordering
    assert_equal     3,                             new_group.memberships[2].ordering
  end
end
