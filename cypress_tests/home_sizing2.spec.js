describe("Some describe", () => {
    before(() => {
      cy.visit('index.html');
    });

    describe("Desktop", () => {
      before(() => {
        cy.viewport(1440, 900) // view for MacBook 15
      })
      it ('checks for size', () => {
        cy.contains('Home')
    })
    });
  });
