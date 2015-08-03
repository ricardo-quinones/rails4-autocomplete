require 'test_helper'

module Rails4Autocomplete
  class Rails4AutocompleteTest < ActionController::TestCase
    ActorsController = Class.new(ActionController::Base)
    ActorsController.autocomplete(:movie, :name)

    class ::Movie ; end

    context '#autocomplete_object_method' do
      setup do
        @controller = ActorsController.new
        @items = {}
        @options = { :display_value => :name }
        @default_params = {"controller"=>"rails4_autocomplete/rails4_autocomplete_test/actors", "action"=>"autocomplete_movie_name"}.with_indifferent_access
      end

      should 'respond to the action' do
        assert_respond_to @controller, :autocomplete_movie_name
      end

      should 'render the JSON items' do
        passed_in_options = @options.merge(params: @default_params.merge(term: 'query'))
        mock(@controller).get_autocomplete_items({
          :model => Movie, :method => :name, :options => passed_in_options, :term => "query"
        }) { @items }

        mock(@controller).json_for_autocomplete(@items, :name, nil)
        get :autocomplete_movie_name, :term => 'query'
      end

      context 'no term is specified' do
        should "render an empty hash" do
          mock(@controller).json_for_autocomplete({}, :name, nil)
          get :autocomplete_movie_name
        end
      end
    end
  end
end
