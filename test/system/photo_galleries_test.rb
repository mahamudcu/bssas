require "application_system_test_case"

class PhotoGalleriesTest < ApplicationSystemTestCase
  setup do
    @photo_gallery = photo_galleries(:one)
  end

  test "visiting the index" do
    visit photo_galleries_url
    assert_selector "h1", text: "Photo Galleries"
  end

  test "creating a Photo gallery" do
    visit photo_galleries_url
    click_on "New Photo Gallery"

    fill_in "Description", with: @photo_gallery.description
    fill_in "Image", with: @photo_gallery.image
    fill_in "Title", with: @photo_gallery.title
    click_on "Create Photo gallery"

    assert_text "Photo gallery was successfully created"
    click_on "Back"
  end

  test "updating a Photo gallery" do
    visit photo_galleries_url
    click_on "Edit", match: :first

    fill_in "Description", with: @photo_gallery.description
    fill_in "Image", with: @photo_gallery.image
    fill_in "Title", with: @photo_gallery.title
    click_on "Update Photo gallery"

    assert_text "Photo gallery was successfully updated"
    click_on "Back"
  end

  test "destroying a Photo gallery" do
    visit photo_galleries_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Photo gallery was successfully destroyed"
  end
end
