require 'spec_helper'

describe ApplicationHelper do

  subject { helper }

  describe "#link_if_exists" do
    let(:uploaded_file) { double("InputFileUploader") }

    before do
      uploaded_file.stub_chain(:file, :identifier).and_return('test_file_name.csv')
      uploaded_file.stub(:url).and_return('assets/test_file_name.csv')
      uploaded_file.stub(:current_path).and_return('uploads/test_file_name.csv')
    end

    it "should return a link if the file exists" do
      File.stub!(:exists?).and_return(true)
      helper.link_if_exists(uploaded_file).should == helper.link_to('test_file_name.csv', 'assets/test_file_name.csv')
    end

    it "should return a span tag if file does not exist" do
      File.stub!(:exists?).and_return(false)
      helper.link_if_exists(uploaded_file).should == helper.content_tag(:span, 'test_file_name.csv')
    end
  end
end