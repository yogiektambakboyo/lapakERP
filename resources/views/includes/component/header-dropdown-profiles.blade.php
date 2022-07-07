<div class="dropdown-menu dropdown-menu-end me-1">
	<a href="javascript:;" class="dropdown-item">Edit Profile</a>
	<a href="javascript:;" class="dropdown-item">Setting</a>
	<div class="dropdown-divider"></div>
	@auth
		<a href="{{ route('logout.perform') }}" class="dropdown-item">Log Out</a>
	@endauth
</div>