require_relative '../spec_helper'

shared_examples "config file creator" do |target_file, content, mode|
  it "creates the configuration file from cookbook file" do
    expect(runner).to create_cookbook_file(target_file).
                       with(user: 'root', group: 'root', mode: mode)
  end

  it "creates the configuration file with the right content" do
    expect(runner).to render_file(target_file).with_content(content)
  end

end

shared_examples "config template creator" do |target_file, content, mode|
  it "creates the configuration file from template" do
    expect(runner).to create_template(target_file).
                       with(user: 'root', group: 'root', mode: mode)
  end

  it "creates the configuration file with the right content" do
    expect(runner).to render_file(target_file).with_content(content)
  end

end
