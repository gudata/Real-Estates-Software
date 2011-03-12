module Admin::ContactsHelper
  def contact_type(contact)
    contact.is_company == true ? t("company", :scope => [:admin, :contacts]) : t("person", :scope => [:admin, :contacts])
  end

  def contact_types
    [[t("company", :scope => [:admin, :contacts]), true], [t("person", :scope => [:admin, :contacts]), false]]
  end

end
