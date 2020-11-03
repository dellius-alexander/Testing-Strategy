//clicks on contact page
describe('Hyfi Solutions', () => {
    it('clicks the link "type"', () => {
      cy.visit('https://dellius-alexander.github.io/responsive_web_design/index.html')
  
      cy.contains('Contact').click()
         })
  })
