require 'active_record' unless defined? ActiveRecord
require 'active_support' unless defined? ActiveSupport

module Lifespan

  def self.included(klazz)
    klazz.extend Query
  end

  module Query
    def without_lifespan
      self.default_scopes.each do |scope|
        self.default_scopes.delete(scope) if scope.source_location[0].eql?(__FILE__)
      end
      all
    end
  end
end

class ActiveRecord::Base
  ##
  # This +lifespan+ extension provides filtering of record at the start_at and end_at.
  # Automatically adding to default_scope.
  # without_lifespan method a good job.
  # It is not erased only default_scope itself has added.
  #
  # Configuration options are:
  #
  # * +start_at_column+ - column name for start datetime columne, default +start_at+
  # * +end_at_column+ - column name for end datetime columne, default +end_at+
  #
  # Example Option:
  #
  # class Article < ActiveRecord::Base
  #   lifespan start_at_column: "start_on"
  # end
  #
  # How to use:
  #
  # Article.all
  # => SELECT
  #      `articles`.*
  #    FROM
  #      `articles`
  #    WHERE
  #      (`articles`.`start_at` <= '2115-03-31 15:00:00.000072') AND
  #      (`articles`.`end_at` > '2115-03-31 15:00:00.000072' OR `articles`.`end_at` IS NULL);
  #
  def self.lifespan(options={})
    include Lifespan

    class_attribute :start_at_column, :end_at_column

    self.start_at_column = (options[:start_at_column] || :start_at).to_s
    self.end_at_column   = (options[:end_at_column]   || :end_at).to_s

    def self.lifespan_scope
      #TODO Time.zone.nowの方が良い？
      now = Time.now
      where(arel_table[start_at_column].lteq now)
      .where(arel_table[end_at_column].gt(now).or arel_table[end_at_column].eq(nil))
    end
    default_scope { lifespan_scope }
  end
end
