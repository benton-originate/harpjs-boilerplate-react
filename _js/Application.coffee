React = require 'react'
d3 = require 'd3'
rootDOM = 'body' # DOM id for Application to be inserted into


d3Chart =
  create: (el, props, state) ->
    svg = d3.select(el).append('svg')
      .attr('class', 'd3')
      .attr('width', props.width)
      .attr('height', props.height)

    svg.append('g')
        .attr('class', 'd3-points')

    @update(el, state)

  update: (el, state) ->
    scales = @_scales(el, state.domain)
    @_drawPoints(el, scales, state.data)

  destroy: (el) ->

  _drawPoints: (el, scales, data) ->
    g = d3.select(el).selectAll('.d3-points')
    point = g.selectAll('.d3-point')
      .data(data, ((d) -> d.id) )

    point.enter().append('circle')
        .attr('class', 'd3-point')

    point.attr('cx', (d) -> scales.x(d.x))
        .attr('cy', (d) -> scales.y(d.y))
        .attr('r', (d) -> scales.z(d.z))

    point.exit().remove()

  _scales: (el, domain) ->
    return null if !domain

    width = el.offsetWidth
    height = el.offsetHeight

    x = d3.scale.linear()
      .range([0, width])
      .domain(domain.x)

    y = d3.scale.linear()
      .range([height, 0])
      .domain(domain.y)

    z = d3.scale.linear()
      .range([5, 20])
      .domain([1, 10])

    {x, y, z}


Chart = React.createClass

  propTypes:
    data: React.PropTypes.array
    domain: React.PropTypes.object

  componentDidMount: ->
    el = @getDOMNode()
    d3Chart.create el, { width: '100%', height: '300px' }, @getChartState()

  componentDidUpdate: ->
    el = @getDOMNode()
    d3Chart.update(el, @getChartState())

  getChartState: ->
    data: this.props.data
    domain: this.props.domain

  componentWillUnmount: ->
    el = @getDOMNode()
    d3Chart.destroy(el)

  render: ->
    React.DOM.div {className: "Chart"}
    #return (
    #  <div className="Chart"></div>
    #)


sampleData = [
  {id: '5fbmzmtc', x: 7, y: 41, z: 6},
  {id: 's4f8phwm', x: 11, y: 45, z: 9}
]

Application = React.createClass
  #render: ->
  #  {div} = React.DOM

  getInitialState: ->
    data: sampleData,
    domain: {x: [0, 30], y: [0, 100]}

  render: ->
    React.DOM.div {className: 'App'},
      React.createElement(Chart, { data: this.state.data, domain: this.state.domain})

    #div className: 'application', 'Hello Worldasdf'


module.exports =
  init: ->
    React.renderComponent(Application(), document.getElementById(rootDOM))
    #React.render(React.createElement(Application, null), document.getElementById(rootDOM))
