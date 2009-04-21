require File.dirname(__FILE__) + "/../test_helper.rb"

class Ubiquo::ActiveRecordHelpersTest < ActiveSupport::TestCase

  def setup
    create_ar_test_backend
    set_test_model_as_translatable
  end
  
  def test_simple_filter
    create_model(:content_id => 1, :locale => 'es')
    create_model(:content_id => 1, :locale => 'ca')
    assert_equal 1, TestModel.locale(['es']).size
    assert_equal 'es', TestModel.locale(['es']).first.locale
  end
  
  def test_many_contents
    create_model(:content_id => 1, :locale => 'es')
    create_model(:content_id => 2, :locale => 'es')
    assert_equal 2, TestModel.locale(['es']).size
    assert_equal ['es', 'es'], TestModel.locale(['es']).map(&:locale)
  end
  
  def test_many_locales_many_contents
    create_model(:content_id => 1, :locale => 'es')
    create_model(:content_id => 1, :locale => 'ca')
    create_model(:content_id => 2, :locale => 'es')
    
    assert_equal 2, TestModel.locale(['es']).size
    assert_equal 1, TestModel.locale(['ca']).size
    assert_equal 2, TestModel.locale(['ca', 'es']).size
    assert_equal ['ca', 'es'], TestModel.locale(['ca', 'es']).map(&:locale)
  end
  
  private
      
  def create_model(options = {})
    TestModel.create(options)
  end

  def create_ar_test_backend
    # Creates a test table for AR things work properly
    if ActiveRecord::Base.connection.tables.include?("test_models")
      ActiveRecord::Base.connection.drop_table :test_models
    end
    ActiveRecord::Base.connection.create_table :test_models, :translatable => true do
    end
  end
  
  def set_test_model_as_translatable
    TestModel.class_eval do
      translatable
    end
  end
end

# Model used to test Versionable extensions
TestModel = Class.new(ActiveRecord::Base)