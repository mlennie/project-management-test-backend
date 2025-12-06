class AddUserToProjects < ActiveRecord::Migration[8.1]
  def change
    add_reference :projects, :user, null: true, foreign_key: true

    reversible do |dir|
      dir.up do
        # Backfill existing projects to a system user to satisfy NOT NULL constraint
        system_user = User.find_or_create_by!(email: "system@example.com") do |u|
          u.password = SecureRandom.hex(16)
          u.password_confirmation = u.password
        end
        Project.where(user_id: nil).update_all(user_id: system_user.id)
      end
    end

    change_column_null :projects, :user_id, false
  end
end
