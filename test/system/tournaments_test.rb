require "application_system_test_case"

class TournamentsTest < ApplicationSystemTestCase
    setup :setup_log_in

    test "Check the tournament list" do
        visit user_tournaments_path(@user)

        assert_selector "h1", text: /^Challonge tournaments owned by/

        # The footer should have three links.
        assert_link "Reload the tournament list from Challonge",
                    href: user_tournaments_refresh_path(@user), exact: true
        assert_link "Change this user's settings", href: edit_user_path(@user), exact: true
        assert_link "Log out", href: logout_path, exact: true

        # Check the column headers in the tournament table.
        header_text = %w(Name State Actions Links)

        page.all("th").each_with_index do |th, i|
            assert th.text == header_text[i]
        end

        # Check the list of tournaments.
        page.all("tbody tr").each do |tr|
            tr.all("td").each_with_index do |td, i|
                case i
                    when 0, 1
                        # The Name and State columns should have text.
                        assert td.text.present?
                    when 2
                        # The Actions column should have two links.
                        assert td.has_link? "Manage this tournament", exact: true
                        assert td.has_link? "Change settings", exact: true
                    when 3
                        # The Links column should have three links.
                        assert td.has_link? "Challonge", exact: true
                        assert td.has_link? "Spectator view", exact: true
                        assert td.has_link? "Kiosk", exact: true

                        # Check that the "Challonge" link points to a valid
                        # Challonge URL.
                        uri = URI.parse(td.find("a:nth-child(1)")[:href])

                        assert uri.host =~ /^([^.]+\.)?challonge\.com$/
                        assert uri.path =~ /^\/\w+$/
                end
            end
        end
    end

    test "Check the tournament settings page" do
        visit user_tournaments_path(@user)

        begin
            # If the user has no tournaments, this call will throw an exception,
            # but we don't treat that as a test failure.
            row_elt = page.find("tbody tr:first-child")
        rescue Capybara::ElementNotFound
            puts "Warning: The test user has no tournaments. This test is not" \
                   " running any assertions."
        end

        if row_elt
            edit_settings_link = row_elt.find("td:nth-child(3) a:nth-child(2)")
            tournament_url = edit_settings_link["href"]
            assert_equal "/edit", tournament_url.slice!(%r{/[^/]+$})

            edit_settings_link.click

            assert_selector "h1", text: /^Change settings for/
            assert_selector "label", exact_text: "The Gold cabinet is on the left side"
            assert_field id: "tournament_gold_on_left", type: "checkbox"
            assert_selector "label", exact_text: "Send Slack notifications when " \
                                                   "matches begin and end"
            assert_field id: "tournament_send_slack_notifications", type: "checkbox"
            assert_selector "label", exact_text: "Slack channel:"
            assert_field name: "tournament[slack_notifications_channel]", type: "text"

            page.find_by_id("tournament_gold_on_left").click
            page.find_by_id("tournament_send_slack_notifications").click
            fill_in "tournament[slack_notifications_channel]", with: "ucsunnydale"

            VCR.use_cassette("get_tournament_info") do
                click_on "Update Tournament"

                assert_current_path(tournament_url)
            end
        end
    end

    test "Check the show-tournament page" do
        visit user_tournaments_path(@user)

        begin
            # If the user has no tournaments, this call will throw an exception,
            # but we don't treat that as a test failure.
            row_elt = page.find("tbody tr:first-child")
        rescue Capybara::ElementNotFound
            puts "Warning: The test user has no tournaments. This test is not" \
                   " running any assertions."
        end

        if row_elt
            manage_link = row_elt.find("td:nth-child(3) a:nth-child(1)")
            manage_url = manage_link["href"]
            tournament_id = manage_url.match(%r{/tournaments/(\d+)})[1]
            tournament = @user.tournaments.find(tournament_id)

            VCR.use_cassette("get_tournament_info") do
                manage_link.click

                # This call has to be within the use_cassette block, because
                # `click` returns right away.  `assert_selector` spins, looking
                # for the element, and the HTTP request happens during that loop.
                assert_selector "h1", exact_text: tournament.name
            end

            assert_link "Challonge bracket", href: tournament.challonge_url,
                        exact: true
            assert_link "Spectator view", href: view_tournament_path(tournament.challonge_alphanumeric_id),
                        exact: true
            assert_link "Kiosk", href: tournament_kiosk_path(tournament.challonge_alphanumeric_id),
                        exact: true

            # Since this is using live data from Challonge, we can't predict
            # what the Upcoming Matches, Completed Matches, and Team Records
            # sections will contain.  The Team Records section will always exist,
            # so we can look for that.
            assert_selector "h2", exact_text: "Team records:"
            assert_selector "th", exact_text: "Seed"
            assert_selector "th", exact_text: "Team (W-L)"

            assert_link "Reload this tournament from Challonge",
                        href: refresh_user_tournament_path(@user, tournament),
                        exact: true

            assert_link "Change settings",
                        href: edit_user_tournament_path(@user, tournament),
                        exact: true

            assert_link "Back to the tournament list",
                        href: user_tournaments_path(@user), exact: true

            assert_link "Log Out", href: logout_path, exact: true
        end
    end
end
