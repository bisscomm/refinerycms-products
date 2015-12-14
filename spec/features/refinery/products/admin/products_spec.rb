# encoding: utf-8
require "spec_helper"

module Refinery
  module Products
    module Admin
      describe "products", type: :feature do
        refinery_login

        describe "products list" do
          before do
            FactoryGirl.create(:product, :title => "UniqueTitleOne")
            FactoryGirl.create(:product, :title => "UniqueTitleTwo")
          end

          it "shows two items" do
            visit refinery.products_admin_products_path
            expect(page).to have_content("UniqueTitleOne")
            expect(page).to have_content("UniqueTitleTwo")
          end
        end

        describe "create" do
          before do
            visit refinery.products_admin_products_path

            click_link "Create new product"
          end

          context "valid data" do
            it "should succeed" do
              fill_in "Title", :with => "This is a test of the first string field"
              click_button "Save"

              expect(page).to have_content("'This is a test of the first string field' was successfully added.")
              expect(Refinery::Products::Product.count).to eq 1
            end
          end

          context "invalid data" do
            it "should fail" do
              click_button "Save"

              expect(page).to have_content("Title can't be blank")
              expect(Refinery::Products::Product.count).to eq 0
            end
          end

          context "duplicate" do
            before { FactoryGirl.create(:product, :title => "UniqueTitle") }

            it "should fail" do
              visit refinery.products_admin_products_path

              click_link "Create new product"

              fill_in "Title", :with => "UniqueTitle"
              click_button "Save"

              expect(page).to have_content("There were problems")
              expect(Refinery::Products::Product.count).to eq 1
            end
          end

        end

        describe "edit" do
          before { FactoryGirl.create(:product, :title => "A title") }

          it "should succeed" do
            visit refinery.products_admin_products_path

            within ".actions" do
              click_link "Edit this product"
            end

            fill_in "Title", :with => "A different title"
            click_button "Save"

            expect(page).to have_content("'A different title' was successfully updated.")
            expect(page).not_to have_content("A title")
          end
        end

        describe "destroy" do
          before { FactoryGirl.create(:product, :title => "UniqueTitleOne") }

          it "should succeed" do
            visit refinery.products_admin_products_path

            click_link "Remove this product forever"

            expect(page).to have_content("'UniqueTitleOne' was successfully removed.")
            expect(Refinery::Products::Product.count).to eq 0
          end
        end

      end
    end
  end
end
