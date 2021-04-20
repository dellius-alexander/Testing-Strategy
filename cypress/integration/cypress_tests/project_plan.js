describe('Project Plan Form', () => {
    it('fills the form', () => {
      cy.visit('https://dellius-alexander.github.io/responsive_web_design/project.html');
      cy.get('#fName').type('John')
      cy.pause
      cy.get('#lName').type('Doe')
      cy.pause
      cy.get('#saddress').type('123 Example Street')
      cy.get('#city').type('Morrow')
      cy.get('#state').select('GA')
      cy.get('#zipcode').type('30260')
      cy.get('#email').type('johndoe@gmail.com')
      cy.get('#phone').type('6781234567')
      cy.get('#organization').type('Research Group Organization')
      cy.get('#organization').click('Research Group Organization')

    })
  })