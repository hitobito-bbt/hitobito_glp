# encoding: utf-8

#  Copyright (c) 2012-2019, GLP Schweiz. This file is part of
#  hitobito_glp and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_glp.


module Glp
  module Devise::SessionsController
    extend ActiveSupport::Concern
    include TwoFactorAuthentication

    private

    def create # rubocop:disable Metrics/MethodLength
      if first_factor_authenticated? && two_factor_authentication_required?
        sign_out
        if too_man_tries?
          flash[:alert] = 'Zu viele falsche 2FA-Codes, bitte versuche es morgen wieder'
          redirect_to '/'
        else
          if send_two_factor_authentication_code
            redirect_to users_two_factor_authentication_confirmation_path(person: { id: person.id })
          else
            flash[:alert] = 'Die Zustellung des 2FA-Codes hat nicht geklappt, ' \
              'bitte kontaktiere das Generalsekretariat'
            redirect_to '/'
          end
        end
      else
        super
      end
    end

    def person
      @person ||= ::Person.find_by(email: params[:person][:email])
    end
  end
end
