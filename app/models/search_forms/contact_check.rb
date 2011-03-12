class ContactCheck
  attr :phones_number_clean_contains
  attr :internet_comunicators_value_eq
  
  def initialize params
    @phones_number_clean_contains = params[:phones_number_clean_contains]
    @internet_comunicators_value_eq = params[:internet_comunicators_value_eq]
    @cleaned_phone = "#{@phones_number_clean_contains}".gsub(/[^\d]/, '')
  end

  def get_contacts contacts
    if @phones_number_clean_contains and !@phones_number_clean_contains.blank?
      contacts = contacts.where(["phones.number_clean like :number", {:number=> "%#{@cleaned_phone}%"}])
    end
    if @internet_comunicators_value_eq and !@internet_comunicators_value_eq.blank?
      contacts = contacts.where ["internet_comunicators.value = :email", {
          :email => @internet_comunicators_value_eq.strip
        }]
    end
    contacts
  end

  
  def valid_search
    message = ""
    if (@internet_comunicators_value_eq.blank? and @cleaned_phone.blank?)
      message = I18n::t("Емайл или телефон задължителни", :scope => [:admin, :contacts])
      status = false
      return  [message, status]
    end

    status = true
    valid_phone = (
      !@cleaned_phone.blank? and
        @cleaned_phone.size > 5 and
        !@cleaned_phone.match(/^\s$/)
    )
    valid_email = (
      !@internet_comunicators_value_eq.blank? and
        self.internet_comunicators_value_eq.size > 5 and
        self.internet_comunicators_value_eq.strip.match(/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i) != nil
    )

    return [message, true] if valid_phone && valid_email

    if (!@cleaned_phone.blank? and !valid_phone)
      message = I18n::t("Грешка в полето телефон", :scope => [:admin, :contacts])
      status = false
    end

    if (!@internet_comunicators_value_eq.blank? and !valid_email)
      message = I18n::t("Грешка в полето емайл", :scope => [:admin, :contacts])
      status = false
    end

    [message, status]
  end

end
