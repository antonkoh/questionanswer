shared_examples_for "API Single Contents" do |parameters|

    let(:path_prefix) {((defined? substitute_path_prefix) ? path_prefix : "")}
    let(:single_name) {((defined? substitute_single_name) ? substitute_single_name : single.class.to_s.downcase)}

    parameters.split(' ').each do |attr|
      it "item contains #{attr}" do
        expect(response.body).to be_json_eql(single.send(attr).to_json).at_path([path_prefix,single_name,attr].reject(&:empty?).join('/'))
      end
    end



end