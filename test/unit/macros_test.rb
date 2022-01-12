# frozen_string_literal: true

require File.expand_path('../../test_helper', __FILE__)

class Redmine::WikiFormatting::Macro < ActiveSupport::TestCase
  include ApplicationHelper
  include ActionView::Helpers::TranslationHelper
  include ERB::Util

  fixtures :issues

  def test_macro_sql_no_argument
    text = "{{sql}}"
    assert_match %r{<p><div class=\"flash error\">}, textilizable(text)
  end

  def test_macro_sql_no_result
    text = <<~MACRO
      {{sql
      SELECT id FROM issues WHERE ID > 15
      }}
    MACRO
    assert_equal "<p><table class=\"list issue-report\"><thead><tr><th>id</th></tr></thead></table></p>", textilizable(text)
  end

  def test_macro_sql_placeholder_onw_result
    text = <<~MACRO
      {{sql(10)
      SELECT count(*) as count FROM issues WHERE ID > ?
      }}
    MACRO
    assert_equal "<p><table class=\"list issue-report\"><thead><tr><th>count</th></tr></thead><tbody><tr><td>4</td></tr></tbody></table></p>", textilizable(text)
  end
end
