#!/usr/bin/python3
"""
This module defines API routes for the Naviplus backend.

It registers viewsets with a default router:
- /api/buildings/
- /api/plds/
- /api/user-profiles/

These endpoints are secured with token-based authentication.
"""

from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import BuildingViewSet, PLDViewSet, UserProfileViewSet
from .views import signup
from rest_framework.authtoken import views as auth_views

# Initialize default router for ViewSets
router = DefaultRouter()
router.register(r'buildings', BuildingViewSet, basename='building')
router.register(r'plds', PLDViewSet, basename='pld')
router.register(r'user-profiles', UserProfileViewSet, basename='userprofile')

# Include all generated routes
urlpatterns = [
    path('', include(router.urls)),
    path('signup/', signup, name='signup'),
    path('login/', auth_views.obtain_auth_token, name='login'),
]