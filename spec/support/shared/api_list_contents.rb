shared_examples_for "API List Contents" do |parameters, absent_parameters = nil|

    let!(:path_prefix) {((defined? substitute_path_prefix) ? substitute_path_prefix : "")}
    let!(:contents_name) {((defined? substitute_contents_name) ? substitute_contents_name : contents.first.class.to_s.pluralize.downcase)}

    it "returns list" do
      expect(response.body).to have_json_size(contents.size).at_path([path_prefix,contents_name].reject(&:empty?).join('/'))
    end

    parameters.split(' ').each do |attr|
      it "item contains #{attr}" do
        expect(response.body).to be_json_eql(contents.first.send(attr).to_json).at_path([path_prefix,contents_name,'0',attr].reject(&:empty?).join('/'))
      end
    end

    if absent_parameters
      absent_parameters.split(' ').each do |attr|
        it "item contains #{attr}" do
          expect(response.body).to_not have_json_path([path_prefix,contents_name,'0',attr].reject(&:empty?).join('/'))
        end
      end
    end

end