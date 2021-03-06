{
    en: {
        blue_cab_name: "Blue",
        browser_title: "%{title} - Challonge Mgr",
        browser_title_view: "Viewing %{title}",
        browser_title_kiosk: "Kiosk for %{title}",
        cancel_link: "Cancel",
        gold_cab_name: "Gold",
        errors: {
            login_required: "You must log in.",
            page_access_denied: "You cannot access that page.",
            match_not_found: "That match was not found.",
            tournament_not_found: "That tournament was not found.",
            user_not_found: "That user was not found.",
            login_failed: "The user name or password was incorrect.",
            cant_finalize_tournament: "The tournament still has unplayed matches" \
                                        " and cannot be finalized yet.",
            invalid_subdomain: "can contain only letters, numbers, and hyphens",
            invalid_api_key: "can contain only letters and numbers"
        },
        notices: {
            user_updated: "The user was updated.",
            tournament_updated: "The tournament was updated.",
            auth_error: "Authentication error. Check that your Challonge user name" \
                          " and API key are correct."
        },
        slack: {
            tbd: "TBD",
            match_starting: "%{tournament_name}: Match #%{match_number} is about to start:" \
                              " %{left_team} vs. %{right_team}.",
            on_deck_match: " The on-deck match is %{first_team} vs. %{second_team}.",
            match_complete: "%{tournament_name}: %{winning_team} defeated" \
                              " %{losing_team} %{winning_score}-%{losing_score}."
        },
        sessions: {
            new: {
                page_title: "Log in",
                account_setup_instructions_html: "Enter the user name and password" \
                  " of your Challonge Mgr account. If you haven't made an account" \
                  " yet, see <a href='%{url}'>the installation instructions</a>" \
                  " on how to set one up.",
                user_name_html: "<u>U</u>ser name:",
                user_name_accesskey: "u",
                password_html: "<u>P</u>assword:",
                password_accesskey: "p",
                log_in_button: "Log in"
            }
        },
        users: {
            show: {
                page_title: "Account settings for %{user_name}",
                page_header: "Account settings for %{user_name}",
                user_name: "User name:",
                api_key: "API key:",
                subdomain: "Subdomain:",
                view_tournaments: "View this user's tournaments"
            },
            edit: {
                page_title: "Change settings for %{user_name}",
                page_header: "Change settings for %{user_name}"
            },
            form: {
                errors_list_header: {
                    one: "1 error prevented the user from being saved:",
                    other: "%{count} errors prevented the user from being saved:"
                },
                api_key_html: "<u>C</u>hallonge API key: (" \
                              "<a target='_blank' href='https://challonge.com/settings/developer'>" \
                              "Find your API key</a>)",
                subdomain_html: "<u>S</u>ubdomain: (Leave this blank if your account doesn't belong to an organization)",
                password_html: "<u>P</u>assword: (Leave this blank to keep your current password)",
                password_confirmation_html: "C<u>o</u>nfirm the new password:",
                api_key_accesskey: "c",
                subdomain_accesskey: "s",
                password_accesskey: "p",
                confirm_password_accesskey: "o"
            },
            edit_user: "Change this user's settings",
            log_out: "Log out"
        },
        tournaments: {
            index: {
                page_title: "Tournament list for %{user_name}",
                page_header: "Challonge tournaments owned by %{user_name}",
                instructions1_html: "This list shows the tournaments that are underway" \
                  " and owned by your user.  Click the <i>Manage this tournament</i>" \
                  " link next to the tournament that you want to manage.",
                instructions2: "If the tournament that you want to manage isn't" \
                  " listed here, check that you have started the" \
                  " tournament on the Challonge web site.  Challonge Mgr can only" \
                  " manage tournaments that have had their teams and seeds set up" \
                  " on the Challonge site.",
                instructions3_html: "If the tournament has been started and isn't" \
                  " listed here, click the <i>Reload the tournament list" \
                  " from Challonge</i> link below the list.",
                quick_start_header: "Quick start demo",
                quick_start_body_html: "If you want to dive right in to Challonge Mgr" \
                  " and you don't have a tournament ready to go, click <i>Create" \
                  " a demo tournament</i>.  This will create a private tournament" \
                  " in your Challonge account so you can try out Challonge Mgr.",
                quick_start_button: "Create a demo tournament",
                hide_quick_start_button: "Hide this section",
                name: "Name",
                links: "Links",
                state: "State",
                actions: "Actions",
                name_with_subdomain: "%{name} [%{subdomain}]",
                challonge: "Challonge",
                spectator_view: "Spectator view",
                kiosk: "Kiosk",
                manage_tournament: "Manage this tournament",
                reload_tournaments: "Reload the tournament list from Challonge",
            },
            show: {
                bracket_link: "Challonge bracket",
                spectator_view_link: "Spectator view",
                kiosk_link: "Kiosk",
                upcoming_matches: "Upcoming matches:",
                completed_matches: "Completed matches:",
                team_records: "Team records:",
                finalize_tournament: "Finalize the tournament:",
                finalize_text_html: "All of the matches in the tournament have been played." \
                  " Click <i>Finalize the tournament</i> to complete the tournament" \
                  " and show the final standings. Once you finalize the tournament," \
                  " no more changes can be made to it.",
                finalize_tournament_button: "Finalize the tournament",
                final_standings: "Final standings:",
                group_stage_end: "The group stage of this tournament has ended.",
                group_stage_end_text_html: "Click the \"End the group stage\" button " \
                  "on <a href='%{bracket_url}' target='_blank'>the Challonge bracket</a>, " \
                  "set up the bracket for the final stage, then " \
                  "<a href='%{refresh_url}'>refresh this tournament</a> " \
                  "to manage the second stage.",
                group_stage_end_text_readonly: "The second stage will begin shortly.",
                place: "Place",
                seed: "Seed",
                name: "Team",
                record: "Team (W-L)",
                team_record: "%{name} (%{wins} - %{losses})",
                reload: "Reload this tournament from Challonge",
                tournament_list: "Back to the tournament list"
            },
            edit: {
                page_title: "Change settings for %{name}",
                page_header: "Change settings for %{name}"
            },
            form: {
                errors_list_header: {
                    one: "1 error prevented the tournament from being saved:",
                    other: "%{count} errors prevented the tournament from being saved:"
                },
                gold_on_left_html: "The <u>G</u>old cabinet is on the left side",
                send_slack_notifications_html: "<u>S</u>end Slack notifications when matches begin and end",
                slack_notifications_channel_html: "Sl<u>a</u>ck channel:",
                gold_on_left_accesskey: "g",
                send_slack_notifications_accesskey: "s",
                slack_notifications_channel_accesskey: "a",
                alt_names_header: "Alternate team names",
                alt_names_instructions_html: "If some team names are too long for" \
                  " your stream overlay, you can enter alternate names here, which" \
                  " will be returned from the <code>/view/[id]/blue</code>" \
                  " and <code>/view/[id]/gold</code> URLs.",
                alt_names_th_name: "Name",
                alt_names_th_alt_name: "Alternate name"
            },
            current_match: {
                header: "Current match: #%{number} in %{round_name}",
                add_a_win: "+1",
                subtract_a_win: "-1",
                add_a_win_title: "Add a win for this team",
                subtract_a_win_title: "Subtract a win for this team",
                match_winner: "Match winner",
                match_winner_title: "Set this team as the winner of the match",
                switch_sides: "Switch sides",
            },
            match_list: {
                match_number: "Match #",
                round: "Round",
                teams: "Teams",
                actions: "Actions",
                winner_of_match: "Winner of match %{number}",
                loser_of_match: "Loser of match %{number}",
                forfeited: "(forfeited)",
                switch_sides: "Switch sides",
                start_this_match: "Start this match"
            },
            previous_matches: {
                header: "Previous matches:",
                none: "None",
                match_won: "Defeated %{loser} %{winning_score} - %{losing_score}",
                match_won_forfeited: "Defeated %{loser} by forfeit",
                match_lost: "Lost to %{winner} %{winning_score} - %{losing_score}",
                match_lost_forfeited: "Lost to %{winner} by forfeit"
            },
            edit_tournament: "Change settings",
            state_underway: "underway (%{progress}% done)"
        },
        matches: {
            round_names: {
                winners_round: "winners' round %{round}",
                winners_round_cap: "Winners' round %{round}",
                losers_round: "losers' round %{round}",
                losers_round_cap: "Losers' round %{round}",
                round_with_group_cap: "Group %{group}, round %{round}",
                round_with_group: "group %{group}, round %{round}",
                round: "round %{round}",
                round_cap: "Round %{round}"
            }
        },
        kiosk: {
            show: {
                tbd: "TBD",
                current_match: "Current match:",
                on_deck: "On deck:",
                in_the_hole: "After that:"
            }
        },
        quick_start: {
            tournament_name: "Challonge Mgr demo tournament",
            tournament_desc: "This tournament is a quick start demo created by Challonge Mgr",
            team1: "Team Red",
            team2: "Team Orange",
            team3: "Team Yellow",
            team4: "Team Green",
            team5: "Team Blue",
            team6: "Team Violet"
        }
    }
}
