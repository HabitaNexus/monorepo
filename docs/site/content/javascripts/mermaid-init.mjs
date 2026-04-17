// Mermaid diagram initialization with HabitaNexus brand colors
document.addEventListener("DOMContentLoaded", () => {
  if (typeof mermaid !== "undefined") {
    mermaid.initialize({
      startOnLoad: true,
      theme: "base",
      themeVariables: {
        primaryColor: "#27403c",
        primaryTextColor: "#fff",
        primaryBorderColor: "#1A2C29",
        lineColor: "#64746F",
        secondaryColor: "#C97B4B",
        tertiaryColor: "#2DD4BF",
        fontFamily: "Inter, sans-serif",
      },
    });
  }
});
