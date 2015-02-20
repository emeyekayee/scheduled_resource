class @UseBlock
  constructor: -> nil


class @ZTimeHeaderDayUseBlock extends UseBlock
  constructor: -> nil

  @process: (block) ->
    @label       block
    @css_classes block
    block

  @label: (block) ->
    block.label  = block.title

  @css_classes: (block) ->
    # Could just as well come from server.
    classes = 'ZTimeHeaderDayRow '
    block.css_classes = classes



class @ZTimeHeaderHourUseBlock extends UseBlock
  constructor: -> nil

  @process: (block) ->
    @label       block
    @css_classes block
    block

  @label: (block) ->
    block.label  = block.title

  @css_classes: (block) ->
    # Could just as well come from server.
    # classes = 'ZTimeHeaderHourRow '
    # block.css_classes = classes







# Uses these fields of block: title, subtitle, category, category_type,
# Sets these fields of block: label, css_classes
class @StationUseBlock extends UseBlock
  constructor: -> nil

  @process: (block) ->
    @css_classes block
    @label       block
    block

  @label: (block) ->
    block.label  = block.title
    block.label += ":<br> #{block.subtitle}" if block.subtitle
    block.label += "<span class='flags'>#{@flags(block)}</span>"

  @flags: (block) ->
    flags  = ''
    flags += '  hd'  if block.hdtv
    flags += '  new' unless block.previouslyshown
    flags

  @css_classes: (block) ->
    block.css_classes = @ct_name(block) + " " + @to_css_class(block.category)


  @ct_name: (block) ->
    ct = block.category_type || ''
    return '' if /unknown/i.test ct
    "type_#{ct.replace /[^a-z0-9\-_]+/gi, '_'}"

  @to_css_class: (category, clss = null) ->
    return clss if (clss = @memo[ category ])
    @memo[ category ] = @css_class_search category

  @css_class_search: (category) ->
    for key, regex of @categories
      return ('cat_' + key) if regex.test category
    'cat_Unknown'


  @memo: {}

  @categories:
    Action:           /\b(action|adven)/i
    Adult:            /\b(adult|erot)/i
    Animals:          /\b(animal|tiere)/i
    Art_Music:        /\b(art|dance|music|cultur)/i
    Business:         /\b(biz|busine)/i
    Children:         /\b(child|infan|animation)/i
    Comedy:           /\b(comed|entertain|sitcom)/i
    Crime_Mystery:    /\b(crim|myster)/i
    Documentary:      /\b(doc)/i
    Drama:            /\b(drama)/i
    Educational:      /\b(edu|interests)/i
    Food:             /\b(food|cook|drink)/i
    Game:             /\b(game)/i
    Health_Medical:   /\b(health|medic)/i
    History:          /\b(hist)/i
    Horror:           /\b(horror)/i
    HowTo:            /\b(how|home|house|garden)/i
    Misc:             /\b(special|variety|info|collect)/i
    News:             /\b(news|current)/i
    Reality:          /\b(reality)/i
    Romance:          /\b(romance)/i
    SciFi_Fantasy:    /\b(fantasy|sci\\w*\\W*fi)/i
    Science_Nature:   /\b(science|nature|environm)/i
    Shopping:         /\b(shop)/i
    Soaps:            /\b(soaps)/i
    Spiritual:        /\b(spirit|relig)/i
    Sports:           /\b(sport)/i
    Talk:             /\b(talk)/i
    Travel:           /\b(travel)/i
    War:              /\b(war)/i
    Western:          /\b(west)/i


# console.log ChannelUseBlock.css_class_search('action')
# console.log ChannelUseBlock.to_css_class('action')

# block =
#   category_type: 'series'
#   category: 'adventure'

# block = {"airdate":0,"category":"Reality","category_type":"series","chanid":1791,"description":"Alexia enlists Troy's help to find her father.","endtime":"2013-03-04T12:00:00-08:00","first":true,"generic":false,"hdtv":false,"last":true,"listingsource":0,"manualid":0,"originalairdate":"2009-03-28","partnumber":0,"parttotal":0,"pid":"","previouslyshown":1,"programid":"EP010679340014","seriesid":"EP01067934","showtype":"Series","stars":0.0,"starttime":"2013-03-04T11:30:00-08:00","stereo":false,"subtitle":"A Daughter's Mission","subtitled":false,"syndicatedepisodenumber":"204","title":"The Locator"}

# console.log ChannelUseBlock.ct_name block
# console.log ChannelUseBlock.css_classes block
