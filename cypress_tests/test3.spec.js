//clicks on all the pages in web application
describe('Hyfi Solutions', () => {
    it('clicks the link "type"', () => {
      cy.visit('https://dellius-alexander.github.io/responsive_web_design/index.html')
  
      cy.contains('Gallery').click()
      cy.contains('Contact').click()
      cy.contains('Project Plan').click()
      cy.contains('Home').click()
         })
  })
