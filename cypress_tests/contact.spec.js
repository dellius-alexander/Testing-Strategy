//clicks on contact page
describe('Hyfi Solutions', () => {
    it('clicks the link "type"', () => {
      cy.visit('index.html')
  
      cy.contains('Contact').click()
         })
  })
