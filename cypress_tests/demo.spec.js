//clicks on Project Plan Page
describe('Hyfi Solutions', () => {
    it('clicks the link "type"', () => {
      cy.visit('https://dellius-alexander.github.io/responsive_web_design/index.html')
  
      cy.contains('Project Plan').click()
         })
  })
