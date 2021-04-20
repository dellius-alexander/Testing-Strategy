//clicks on the about Us page
describe('Hyfi Solutions', () => {
    it('clicks the link "type"', () => {
      cy.visit('index.html')
  
      cy.contains('About us').click()
    })
  })
