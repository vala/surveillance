class Surveillance.QuestionView extends Backbone.View
  events:
    "change input, select": "processAnswerValues"

  initialize: ->
    @$fields = @getFields()

    @beforeInitialize?()

    @buildModel(required: @fieldRequired(), rules: @branchRules())

    @processAnswerValues()

    @listenTo(@model, "invalid", @refreshErrors)

  processAnswerValues: ->
    fields = @fieldValues()
    answers = @requiredAnswersCount()

    @model.set(fields: fields, fieldsToFill: answers)
    @$(".form-group").removeClass("has-error")

    @afterAnswerValuesProcessing?()

  fieldValues: ->
    _.compact(_.map(@$fields, (el) => @processFieldValue($(el))))

  requiredAnswersCount: ->
    _.keys(_.groupBy(@$fields, (el) -> $(el).attr("name"))).length

  processFieldValue: ($el) ->
    $el.val()

  refreshErrors: ->
    @$(".form-group").addClass("has-error")

  getFields: ->
    @$("input, select").not("[type=hidden]")

  isValid: ->
    @model.isValid()

  fieldRequired: ->
    @$el.data("required")

  branchRules: ->
    @$el.data("branch-rules")

  buildModel: (options) ->
    @model = new Surveillance.Question(options)