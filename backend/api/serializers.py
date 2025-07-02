#!/usr/bin/python3
"""
This module defines Django REST Framework serializers for the Naviplus system.

Serializers:
- BuildingSerializer: For creating and retrieving building data.
- PLDSerializer: For managing building entrance descriptors.
- UserProfileSerializer: For exposing user accessibility metadata.
"""

from rest_framework import serializers
from django.contrib.auth.models import User
from .models import Building, PLD, UserProfile


class BuildingSerializer(serializers.ModelSerializer):
    """
    Serializes Building objects to/from JSON.
    """
    class Meta:
        model = Building
        fields = '__all__'  # Include all fields from Building model


class PLDSerializer(serializers.ModelSerializer):
    """
    Serializes PLD (Physical Location Descriptor) objects.
    """
    class Meta:
        model = PLD
        fields = '__all__'  # Include all fields from PLD model


class UserProfileSerializer(serializers.ModelSerializer):
    """
    Serializes user profile with disability type.
    Allows both read and write operations.
    """

    # Reference the user by ID (writeable)
    user = serializers.PrimaryKeyRelatedField(queryset=User.objects.all())
    class Meta:
        model = UserProfile
        fields = ['user', 'disability_type']
