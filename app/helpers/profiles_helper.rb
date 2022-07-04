module ProfilesHelper
  def profile_avatar profile, size=40
    if profile.avatar.attached?
      profile.avatar.variant(resize: "#{size}x#{size}!")
    else
      "https://picsum.photos/#{size}/#{size}?grayscale"
    end
  end
end
