describe("Some describe", () => {
    before(() => {
      cy.visit('https://dellius-alexander.github.io/responsive_web_design/contact.html');
    });

    describe("Desktop", () => {
      before(() => {
        cy.viewport(1440, 900) // view for MacBook 15
      })
      it ('checks for size', () => {
        cy.contains('Contact')
    })
    });
  });
