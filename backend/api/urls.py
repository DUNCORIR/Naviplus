#!/usr/bin/python3
"""
This module defines API routes for the Naviplus backend.

Registered Endpoints:
- /api/buildings/       → CRUD for Building model
- /api/plds/            → CRUD for PLD model
- /api/user-profiles/   → CRUD for user profiles
- /api/signup/          → Register new user (custom endpoint)
- /api/login/           → Obtain auth token
"""

from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import BuildingViewSet, PLDViewSet, UserProfileViewSet, signup
from rest_framework.authtoken import views as auth_views
from .views import navigate

# Initialize and register routes for viewsets
router = DefaultRouter()
router.register(r'buildings', BuildingViewSet, basename='building')
router.register(r'plds', PLDViewSet, basename='pld')
router.register(r'user-profiles', UserProfileViewSet, basename='userprofile')

# Main API routes
urlpatterns = [
    path('', include(router.urls)),                            # Auto-generated routes from ViewSets
    path('signup/', signup, name='signup'),                    # Custom signup route
    path('login/', auth_views.obtain_auth_token, name='login') # DRF built-in token auth route
    path('navigate/', navigate, name='navigate'),              # Custom navigation endpoint
]