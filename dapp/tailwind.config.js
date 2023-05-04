/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./pages/*.{html,js,jsx}"],
  theme: {
    extend: {
      backgroundImage: {
        'bg-image' : "url('./styles/wojapes.jpg')",
      },
    },
  },
  plugins: [],
}

