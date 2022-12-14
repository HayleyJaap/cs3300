require 'rails_helper'

RSpec.feature "Projects", type: :feature do
  
  context "Create new project" do
    before(:each) do
      testUser = create(:user)
      visit root_path
      sign_in testUser
      visit new_project_path
      within("[@id='epic-form']") do
        fill_in "Title", with: "Test title"
      end
    end

    scenario "should be successful" do

      fill_in "Description", with: "Test description"
      click_button "Submit"
      expect(page).to have_content("Project was successfully created")
    end

    scenario "should fail" do
      click_button "Submit"
      expect(page).to have_content("Description can't be blank")
    end
  end

  context "Update project" do
    let(:project) { Project.create(title: "Test title", description: "Test content") }
    before(:each) do
      testUser = create(:user)
      visit root_path
      sign_in testUser
      visit edit_project_path(project)
    end

    scenario "should be successful" do
      within("[@id='epic-form']") do
        fill_in "Description", with: "New description content"
      end
      click_button "Submit"
      expect(page).to have_content("Project was successfully updated")
    end

    scenario "should fail" do
      within("[@id='epic-form']") do
        fill_in "Description", with: ""
      end
      click_button "Submit"
      expect(page).to have_content("Description can't be blank")
    end
  end

  context "Remove existing project" do
    let!(:project) { Project.create(title: "Test title", description: "Test content") }
    scenario "remove project" do
      testUser = create(:user)
      visit root_path
      sign_in testUser
      visit project_path(project)
      click_button "Destroy"
      expect(page).to have_content("Project was successfully destroyed")
      expect(Project.count).to eq(0)
    end
  end
end
