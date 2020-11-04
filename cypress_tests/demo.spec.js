//clicks on Project Plan Page
describe('Hyfi Solutions', () => {
    it('clicks the link "type"', () => {
      cy.visit('index.html')
  
      cy.contains('Project Plan').click()
         })
  })
