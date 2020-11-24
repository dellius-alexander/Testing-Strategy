describe("Some describe", () => {
    before(() => {
      cy.visit('gallery.html');
    });

    describe("Desktop", () => {
      before(() => {
        cy.viewport(414, 896) // view for iPhone xr
      })
      it ('checks for size', () => {
        cy.contains('Gallery')
    })
    });
  });
