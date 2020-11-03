//clicks on the about Us page
describe('Hyfi Solutions', () => {
    it('clicks the link "type"', () => {
      cy.visit('https://dellius-alexander.github.io/responsive_web_design/index.html')
  
      cy.contains('About us').click()
    })
  })
