shared_examples_for "Attachmentable" do
  it {should have_many(:attachments).dependent(:destroy)}
  it {should accept_nested_attributes_for :attachments}
end