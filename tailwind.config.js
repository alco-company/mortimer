let colors = require("tailwindcss/colors")

module.exports = {
  theme: {
    extend: {
        colors: {
            neutral: colors.slate,
            positive: colors.green,
            urge: colors.violet,
            warning: colors.yellow,
            info: colors.blue,
            critical: colors.red,
        }
    },
  },
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/components/**/*.html.erb',
    './app/components/**/*.rb',
    './app/views/components/**/*.rb',
    './config/locales/*.yml',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  plugins: [
    require("a17t"),
    require('@tailwindcss/forms'),
    require('@tailwindcss/typography')
  ]
}
