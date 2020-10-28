/// <reference types="Cypress" />

//const url = 'http://127.0.0.1:32769/index.html'

context('Actions', () => {
  beforeEach(() => {
    cy.visit('index.html')
  })
  it('cy.viewport() - set the viewport size and dimension', () => {
    cy.xpath('#container > header > a:nth-child(1) > img')


    // https://on.cypress.io/viewport

    // cy.$('ul > :nth-child(1) > a').contains('index.html')
    // cy.viewport(1920, 1080)

    // cy.get('#section1 > a > .img').click()
    // .click()
  })
})
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////


context('Actions', () => {
  beforeEach(() => {
    cy.visit(url)
  })
  it('cy.viewport() - set the viewport size and dimension', () => {
    // https://on.cypress.io/viewport

    cy.get('ul > :nth-child(1) > a').contains('index.html')
    cy.viewport(1920, 1080)

    cy.get('#section1 > a > .img').click()
    .click()
  })
})