@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Edit Sales Order')


@section('content')

<div class="container-fluid">
  <h1>Two grids demo</h1>
  <div class="grid-stack"></div>

  <div class="row">
    <div class="col-sm-12" style="padding-bottom: 25px;">
      <div class="grid-container center">
        <div class="grid-stack" id="simple-grid"></div>
      </div>
    </div>
  </div>

  <div class="row">
    <div class="col-md-2 d-none d-md-block" style="border-right: 1px dashed white;">
      <div id="trash" style="padding: 15px; margin-bottom: 15px;" class="text-center text-white">
        <div>
          <ion-icon name="trash" style="font-size: 400%"></ion-icon>
        </div>
        <div>
          <span>Drop here to remove widget!</span>
        </div>
      </div>
      <div class="text-center card text-white grid-stack-item newWidget">
        <div class="card-body grid-stack-item-content">
          <div>
            <ion-icon name="add-circle" style="font-size: 400%"></ion-icon>
          </div>
          <div>
            <span>Drag me into the dashboard!</span>
          </div>
        </div>
      </div>
    </div>
    <div class="col-sm-12 col-md-10" style="padding-bottom: 25px;">
      <div class="grid-container">
        <div class="grid-stack" id="advanced-grid"></div>
      </div>
    </div>
  </div>

  
</div>

@endsection

@push('scripts')
<script type="text/javascript">
  var items = [
    {content: 'my first widget'}, // will default to location (0,0) and 1x1
    {w: 2, content: 'another longer widget!'} // will be placed next at (1,0) and 2x1
  ];
  var grid = GridStack.init();
  grid.load(items);

  var simple = [
      {x: 0, y: 0, w: 4, h: 2, content: '1'},
      {x: 4, y: 0, w: 4, h: 4, content: '2'},
      {x: 8, y: 0, w: 2, h: 2, content: '<p class="card-text text-center" style="margin-bottom: 0">Drag me!<p class="card-text text-center"style="margin-bottom: 0"><ion-icon name="hand" style="font-size: 300%"></ion-icon>'},
      {x: 10, y: 0, w: 2, h: 2, content: '4'},
      {x: 0, y: 2, w: 2, h: 2, content: '5'},
      {x: 2, y: 2, w: 2, h: 4, content: '6'},
      {x: 8, y: 2, w: 4, h: 2, content: '7'},
      {x: 0, y: 4, w: 2, h: 2, content: '8'},
      {x: 4, y: 4, w: 4, h: 2, content: '9'},
      {x: 8, y: 4, w: 2, h: 2, content: '10'},
      {x: 10, y: 4, w: 2, h: 2, content: '11'},
    ];
   var advanced = [
      {x: 0, y: 0, w: 4, h: 2, content: '1'},
      {x: 4, y: 0, w: 4, h: 4, noMove: true, noResize: true, locked: true, content: 'I can\'t be moved or dragged!<br><ion-icon name="ios-lock" style="font-size:300%"></ion-icon>'},
      {x: 8, y: 0, w: 2, h: 2, minW: 2, noResize: true, content: '<p class="card-text text-center" style="margin-bottom: 0">Drag me!<p class="card-text text-center"style="margin-bottom: 0"><ion-icon name="hand" style="font-size: 300%"></ion-icon><p class="card-text text-center" style="margin-bottom: 0">...but don\'t resize me!</p>'},
      {x: 10, y: 0, w: 2, h: 2, content: '4'},
      {x: 0, y: 2, w: 2, h: 2, content: '5'},
      {x: 2, y: 2, w: 2, h: 4, content: '6'},
      {x: 8, y: 2, w: 4, h: 2, content: '7'},
      {x: 0, y: 4, w: 2, h: 2, content: '8'},
      {x: 4, y: 4, w: 4, h: 2, content: '9'},
      {x: 8, y: 4, w: 2, h: 2, content: '10'},
      {x: 10, y: 4, w: 2, h: 2, content: '11'},
    ];

    var simpleGrid = GridStack.init({
      alwaysShowResizeHandle: /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent),
      margin: 5,
    }, '#simple-grid');
    simpleGrid.load(simple);

    var advGrid = GridStack.init({
      alwaysShowResizeHandle: /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent),
      margin: 5,
      acceptWidgets: true,
      dragIn: '.newWidget',  // class that can be dragged from outside
      dragInOptions: { revert: 'invalid', scroll: false, appendTo: 'body', helper: 'clone' },
      removable: '#trash',
      removeTimeout: 100
    }, '#advanced-grid');
    advGrid.load(advanced);
    
    $('#search').on('submit', function (event) {
      event.preventDefault();
      var searchTerm = $('#searchTerm').val();
      window.open(
        'https://github.com/gridstack/gridstack.js/issues?utf8=%E2%9C%93&q=is%3Aissue+is%3Aopen+' +
        searchTerm,
        '_blank'
      );
    });
    $('.nav-item').on('click', function (event) {
      $('.nav-item').removeClass('active');
      var target = $(event.currentTarget);
      if (target.hasClass('nav-item-highlight')) {
        target.addClass('active');
      }
    });
</script>
@endpush
